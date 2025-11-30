# Spotsteam

## Prerequisites

- **Ruby** 3.3.9
- **Rails** 8.0.3
- **PostgreSQL** 16.10

---

## About the App

Spotsteam integrates Steam and Spotify data for user dashboards, stats, and comparisons.

---

## Setup

### 1. Spotify API

- Go to [Spotify Developer Dashboard](https://developer.spotify.com/)
- Create a new app
- Set the redirect URL to:  
  `http://127.0.0.1:3000/auth/spotify/callback`
- Set APIs used to **Web API**
- Copy your **Client ID** and **Client Secret** to your `.env` file

### 2. Steam API

- Go to [Steam API Key](https://steamcommunity.com/dev)
- Follow the instructions to obtain a Steam Web API Key
- Save the key in your `.env` file

---

## Environment Variables

Create a `.env` file in your project root:

```
CLIENT_ID=your_spotify_client_id
CLIENT_SECRET=your_spotify_client_secret
STEAM_API_KEY=your_steam_api_key
```

---

## Notes

- **Spotify API** only works on `127.0.0.1` address in development.
- **Steam API** only works on `localhost` address in development.
- To connect your accounts, you may need to switch web addresses.
- All other app features work on any web address.

---

## Getting Started

1. Install dependencies:

   ```sh
   bundle install
   ```

2. Set up the database:

   ```sh
   rails db:create db:migrate db:seed
   ```

3. Start the Rails server:

   ```sh
   bin/dev
   ```

4. Visit [http://127.0.0.1:3000](http://127.0.0.1:3000) in your browser.

---
