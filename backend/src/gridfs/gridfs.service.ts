import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { Db, MongoClient, GridFSBucket } from 'mongodb';
import env from '@/configs/configuration';
import { Readable } from 'stream';
import { ObjectId } from 'bson';
import isValidId from '@/utils/isValidId.util';

@Injectable()
export class GridFsService {
  private db: Db;
  private bucket: GridFSBucket;

  constructor() {
    this.connectToDatabase();
  }

  private async connectToDatabase() {
    const client = await MongoClient.connect(env().database.uri);
    this.db = client.db();
    this.bucket = new GridFSBucket(this.db);
  }

  async uploadFile(file: Express.Multer.File) {
    // Create a readable stream from the uploaded file
    const fileStream = Readable.from(file.buffer);

    // Open a write stream to GridFS for the uploaded file
    const uploadStream = this.bucket.openUploadStream(file.originalname);

    // Pipe the file stream to the upload stream
    fileStream.pipe(uploadStream);

    return new Promise((resolve, reject) => {
      uploadStream.on('finish', () => {
        const fileId = uploadStream.id.toString();
        resolve(fileId);
      });
      uploadStream.on('error', reject);
    });
  }

  async downloadFile(fileId: string): Promise<Readable> {
    if (!isValidId(fileId)) {
      throw new HttpException('Image id is invalid', HttpStatus.NOT_FOUND);
    }

    const objectId = new ObjectId(fileId);

    // Find the file by its ObjectId in the fs.files collection
    const fileInfo = await this.db
      .collection('fs.files')
      .find({ _id: objectId })
      .toArray();

    if (fileInfo.length === 0) {
      throw new Error('File not found');
    }

    // Open a download stream for the file
    const downloadStream = this.bucket.openDownloadStream(objectId);

    return downloadStream;
  }

  async deleteFile(filename: string): Promise<boolean> {
    try {
      await this.bucket.delete(new ObjectId(filename));
      return true;
    } catch (error) {
      return false;
    }
  }
}
