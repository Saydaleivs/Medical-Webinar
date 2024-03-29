import * as dotenv from 'dotenv';
dotenv.config();

export default () => ({
  port: parseInt(process.env.PORT, 10) || 8000,
  database: {
    uri: process.env.MONGODB_URI,
  },
});
