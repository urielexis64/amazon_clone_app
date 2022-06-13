// Imports from packages
require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");

// Imports from other files
const authRouter = require("./routes/auth");

const app = express();
const PORT = process.env.PORT ?? 3000;

// Middlewares
app.use(express.json());
app.use(authRouter);

// Connections
mongoose
	.connect(process.env.MONGODB_URI)
	.then(() => {
		console.log("Connected to MongoDB");
	})
	.catch((err) => {
		console.log(err);
	});

app.listen(PORT, () => {
	console.log(`Server started on port ${PORT}`);
});
