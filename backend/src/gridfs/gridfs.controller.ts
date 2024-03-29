import {
  Controller,
  Delete,
  Get,
  HttpException,
  HttpStatus,
  Param,
  Post,
  Res,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { GridFsService } from './gridfs.service';
import { FileInterceptor } from '@nestjs/platform-express';
import { Response } from 'express';

@Controller('files')
export class GridFsController {
  constructor(private readonly gridFsService: GridFsService) {}

  @Post('upload')
  @UseInterceptors(FileInterceptor('file'))
  async uploadFile(@UploadedFile() file: Express.Multer.File) {
    if (!file) {
      throw new HttpException('File not found', HttpStatus.NOT_FOUND);
    }

    return this.gridFsService.uploadFile(file);
  }

  @Get(':filename')
  async downloadFile(
    @Param('filename') filename: string,
    @Res() res: Response,
  ) {
    const fileStream = await this.gridFsService.downloadFile(filename);
    fileStream.pipe(res);
  }

  @Delete(':filename')
  async deleteFile(@Param('filename') filename: string) {
    const result = await this.gridFsService.deleteFile(filename);
    if (!result) {
      throw new HttpException('File not found', HttpStatus.NOT_FOUND);
    }
    return { message: 'File deleted successfully' };
  }
}
