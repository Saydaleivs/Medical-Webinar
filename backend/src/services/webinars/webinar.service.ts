import { CreateWebinarDto } from '@/controllers/webinars/webinars.dto';
import { User, UserRole } from '@/db/interface/user.interface';
import { Webinar } from '@/db/interface/webinar.schema';
import getSecondsFromDate from '@/utils/getSecondsFromDate';
import validateDate from '@/utils/isValidDate';
import isValidId from '@/utils/isValidId.util';
import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';

@Injectable()
export class WebinarsService {
  constructor(
    @InjectModel('Webinar') private readonly webinarModel: Model<Webinar>,
    @InjectModel('User') private readonly userModel: Model<User>,
  ) {}

  async findAll(): Promise<Webinar[]> {
    return this.webinarModel.find().sort({ date: -1 }).exec();
  }

  async create(
    newWebinar: CreateWebinarDto,
  ): Promise<{ webinar: Webinar; notificationSeconds: number }> {
    if (!isValidId(newWebinar.authorId)) {
      throw new HttpException('Author id is invalid', HttpStatus.BAD_REQUEST);
    }

    const author = await this.userModel.findById(newWebinar.authorId);

    if (!author) {
      throw new HttpException('Author not found', HttpStatus.NOT_FOUND);
    }

    if (author.role !== UserRole.Doctor) {
      throw new HttpException(
        'Only doctors are allowed to create webinars',
        HttpStatus.BAD_REQUEST,
      );
    }

    if (!validateDate(newWebinar.date)) {
      throw new HttpException(
        {
          message: ['Webinar must be scheduled within 10 days!'],
          error: 'Bad request',
          statusCode: HttpStatus.BAD_REQUEST,
        },
        HttpStatus.BAD_REQUEST,
      );
    }

    const notificationSeconds = getSecondsFromDate(newWebinar.date);
    const createdWebinar = await this.webinarModel.create({
      ...newWebinar,
      authorUsername: author.username,
    });

    return { webinar: createdWebinar, notificationSeconds };
  }

  async delete(webinarId: string) {
    if (!isValidId(webinarId)) {
      throw new HttpException(
        {
          message: ['Webinar id is invalid'],
          error: 'BAD REQUEST',
          statusCode: HttpStatus.BAD_REQUEST,
        },
        HttpStatus.BAD_REQUEST,
      );
    }

    const deletedWebinar = await this.webinarModel.deleteOne({
      _id: webinarId,
    });

    return deletedWebinar;
  }
}
