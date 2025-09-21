const express = require("express");
const multer = require('multer');
const path = require('path');
require("dotenv").config()
// const authRoutes = require("./routes/authRoute");
const videoRoutes = require("./routes/videoRoute");
const themeRoutes = require("./routes/themeRoute");
const userRoutes = require("./routes/userRoute");
const uploadRoute = require('./routes/uploadRoute');
const subcategoryRoutes = require('./routes/subcategoryRoute');
const { connection, sequelize } = require("./config/postgressDB");
const globalErrorMiddleware = require("./middleware/ErrorMiddleware");
const ApiError = require("./utils/ApiError");
const cors = require("cors");
const morgan = require('morgan')
const fs = require('fs')
const accessLogStream = fs.createWriteStream(path.join(__dirname, 'access.log'), { flags: 'a' })
const app = express();
app.use(express.json());

app.use(cors()); // enable cors
app.use(express.urlencoded({ extended: true }));
app.use(morgan('combined', { stream: accessLogStream }));
app.use(express.static('public'))

const initializeDatabase = async () => {
  const createTableQuery = `
    CREATE TABLE IF NOT EXISTS media (
      id SERIAL PRIMARY KEY,
      image_path VARCHAR(255),
      video_path VARCHAR(255),
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  `;
  await sequelize.query(createTableQuery);

  // Créer les tables pour les sous-catégories
  const createSubcategoriesTable = `
    CREATE TABLE IF NOT EXISTS subcategories (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      name VARCHAR(255) NOT NULL,
      theme_id UUID NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (theme_id) REFERENCES themes(id) ON DELETE CASCADE
    )
  `;
  await sequelize.query(createSubcategoriesTable);

  // Créer la table de liaison video_subcategories
  const createVideoSubcategoriesTable = `
    CREATE TABLE IF NOT EXISTS video_subcategories (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      video_id UUID NOT NULL,
      subcategory_id UUID NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (video_id) REFERENCES videos(id) ON DELETE CASCADE,
      FOREIGN KEY (subcategory_id) REFERENCES subcategories(id) ON DELETE CASCADE,
      UNIQUE(video_id, subcategory_id)
    )
  `;
  await sequelize.query(createVideoSubcategoriesTable);

  console.log('Database tables initialized successfully');
};

// Initialize database on startup
initializeDatabase().catch(console.error);

// Database connection
connection();

app.get('/', (req, res) => {
    res.send(`
    <!DOCTYPE html>
    <html>
      <head>
        <title>Home</title>
      </head>
      <body>
        <h1>Hello, World!</h1>
      </body>
    </html>
  `);
});
// routes



app.use("/api/videos", videoRoutes);
app.use("/api/themes", themeRoutes);
app.use("/api/users", userRoutes);
app.use("/api/upload", uploadRoute);
app.use("/api", subcategoryRoutes);  // ← CORRECTION ICI


// global error handling midleware
app.use(globalErrorMiddleware);

// run listen
const server = app.listen(process.env.PORT || 3000, () => {
  console.log("listening on port " + (process.env.PORT || 3000));
});

// Handle rejection outside express
process.on("unhandledRejection", (err) => {
  console.log(`unhandledRejection Errors: ${err.name} | ${err.message}`);
  server.close(() => {
    console.log("Shutting down...");
    process.exit(1);
  });
});