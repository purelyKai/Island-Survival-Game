const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');
const app = express();

const port = process.env.PORT || 3000;
const jsonFilePath = './scores.json';

// Enable CORS
app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', 'http://localhost:${port}');
    res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
    next();
});

// Enable SharedArrayBuffer
app.use((req, res, next) => {
    res.header('Cross-Origin-Opener-Policy', 'same-origin');
    res.header('Cross-Origin-Embedder-Policy', 'require-corp');
    next();
});

app.use(express.static('public'));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.json());

// Routes
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/public/index.html');
});

app.get('/web/play-game', (req, res) => {
    res.sendFile(__dirname + '/public/web/play-game.html');
});

app.get('/top-scores', (req, res) => {
    res.sendFile(__dirname + '/public/top-scores.html');
});

app.get('/api/top-player', (req, res) => {
    // Read the top player data and send it
    const topPlayerData = readTopPlayerData();
    res.json(topPlayerData);
});

app.post('/api/submit-score', (req, res) => {
    const { username, time } = req.body;

    // Read the existing top player data
    const topPlayerData = readTopPlayerData();

    // Compare the new time with the existing time
    if (time < topPlayerData.time || topPlayerData.time === '-') {
        // Update the top player data if the new time is lower
        topPlayerData.username = username;
        topPlayerData.time = time;

        // Write the updated data to the JSON file
        writeTopPlayerData(topPlayerData);

        res.json({ message: 'Score submitted successfully!' });
    } else {
        res.json({ message: 'Score not submitted. Time is not lower than the existing top score.' });
    }
});

// Function to read the top player data from the JSON file
function readTopPlayerData() {
    const data = fs.readFileSync(jsonFilePath, 'utf8');
    return JSON.parse(data).topPlayer;
}

// Function to write the top player data to the JSON file
function writeTopPlayerData(data) {
    fs.writeFileSync(jsonFilePath, JSON.stringify({ topPlayer: data }, null, 2));
}

// Start the server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});