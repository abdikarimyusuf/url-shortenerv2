const form = document.getElementById("shorten-form");
const input = document.getElementById("url-input");
const result = document.getElementById("result");

form.addEventListener("submit", async (event) => {
    event.preventDefault();

    const url = input.value;

    result.textContent = "Creating short URL...";

    try {
        const response = await fetch("/api/shorten", {
            method: "POST",

            headers: {
                "Content-Type": "application/json"
            },

            body: JSON.stringify({
                url: url
            })
        });

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.detail || "Something went wrong");
        }

        result.innerHTML = `
             <p>Short URL created:</p>
             <a href="${data.short_url}" target="_blank">
            ${data.short_url}
             </a>
        `;

    } catch (error) {
        result.textContent = `Error: ${error.message}`;
    }
});