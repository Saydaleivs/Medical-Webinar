import * as mongoose from 'mongoose';

export const WebinarSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
  },
  date: {
    type: String,
    required: true,
  },
  authorId: {
    type: String,
    required: true,
  },
  authorUsername: {
    type: String,
    required: true,
  },
  image: String,
});
