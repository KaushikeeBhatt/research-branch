import cors from "cors";
import dotenv from "dotenv";
import express from "express";
import { verifyJWT } from "./middlewares/verify-jwt.js";
import AIRouter from "./routes/ai/index.js";
import AuthRouter from "./routes/auth/index.js";
import IdeaRouter from "./routes/idea/index.js";
import UserRouter from "./routes/user/index.js";

// Loading Environment Variables
dotenv.config();

const PORT = process.env.PORT || 4000;

const app = express();

app.use(cors({ origin: "*", methods: "*", allowedHeaders: "*", credentials: true }));

// Registering Middleware
app.use(express.json());

// Registering Routes
app.get("/", (req, res) => {
  res.status(200).json({ status: "OK", message: "The server is up and running!" });
});

app.use("/auth", AuthRouter);

app.use(verifyJWT);
app.use("/idea", IdeaRouter);
app.use("/user", UserRouter);

app.use("/ai", AIRouter);

// Starting the Server
app.listen(PORT, () => {
  console.log(`[server]: listening on http://127.0.0.1:${PORT}`);
});
