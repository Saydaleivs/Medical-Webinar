import { Document } from 'mongoose';

export interface Webinar extends Document {
  title: string;
  date: string;
  authorId: string;
  authorUsername: string;
  image: string;
}
