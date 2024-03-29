import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User } from '@/db/interface/user.interface';
import { CreateUserDto } from '@/controllers/users/users.dto';
import isValidId from '@/utils/isValidId.util';

@Injectable()
export class UsersService {
  constructor(@InjectModel('User') private readonly userModel: Model<User>) {}

  async findAll(): Promise<User[]> {
    return this.userModel.find().exec();
  }

  async findOne(id: string): Promise<User> {
    if (!isValidId(id)) {
      throw new HttpException('Id is invalid', HttpStatus.NOT_FOUND);
    }

    return this.userModel.findById(id).exec();
  }

  async findByUsername(username: string): Promise<User> {
    return this.userModel.findOne({ username });
  }

  async create(createUserDto: CreateUserDto): Promise<User> {
    const availaleUser = await this.findByUsername(createUserDto.username);
    if (availaleUser) {
      console.log(availaleUser);

      return availaleUser;
    }

    const createdUser = new this.userModel(createUserDto);
    return createdUser.save();
  }
}
