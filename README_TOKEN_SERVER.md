# Stream Chat Token Server (Node.js)

This is a Node.js backend for generating Stream Chat JWT tokens for production use with your MedTalk Flutter app.

---

## 1. Setup

1. **Install dependencies**
   ```bash
   npm install express stream-chat cors dotenv
   ```

2. **Configure Stream credentials**
   - Copy `.env.token_server` to `.env` in the same directory as `getstream-token-server.js`.
   - Edit `.env` and set your actual Stream API key and secret:
     ```env
     STREAM_API_KEY=your_stream_api_key
     STREAM_API_SECRET=your_stream_api_secret
     ```

---

## 2. Running Locally

```bash
node getstream-token-server.js
```
- The server will run at `http://localhost:3000` by default.

---

## 3. Usage

### Get a token for a user:
```
GET http://localhost:3000/token?user_id=USER_ID
```
- Returns: `{ "token": "..." }`

---

## 4. Deploying

You can deploy this to any Node.js host (Heroku, Vercel, Render, AWS, etc). Just set the environment variables for your Stream credentials.

---

## 5. Flutter Integration

In your Flutter app, call this endpoint to fetch a user token before connecting to Stream Chat.

---

**Security Note:** Never expose your Stream API secret to the client or in public code repositories. This backend must be kept private.
