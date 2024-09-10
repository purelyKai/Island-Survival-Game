document.addEventListener('DOMContentLoaded', () => {
    const scoreForm = document.getElementById('scoreForm');
    const topUsernameElement = document.getElementById('topUsername');
    const topTimeElement = document.getElementById('topTime');

    // Function to fetch and update the top player data
    async function updateTopPlayerData() {
        try {
            const response = await fetch('http://localhost:3000/api/top-player');
            const topPlayerData = await response.json();

            // Update the UI with the fetched data
            topUsernameElement.textContent = topPlayerData.username;
            topTimeElement.textContent = topPlayerData.time;
        } catch (error) {
            console.error('Error fetching top player data:', error);
        }
    }

    // Initial update of top player data when the page loads
    updateTopPlayerData();

    // Event listener for form submission
    scoreForm.addEventListener('submit', async (event) => {
        event.preventDefault();

        const username = document.getElementById('username').value;
        const time = document.getElementById('time').value;

        // Submit the form data to the server
        const response = await fetch('http://localhost:3000/api/submit-score', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ username, time }),
        });

        const result = await response.json();
        console.log(result);

        // Update the UI with the latest top player data after submission
        updateTopPlayerData();
    });
});