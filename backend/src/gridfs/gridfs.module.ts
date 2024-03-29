import { Module } from '@nestjs/common';
import { GridFsController } from './gridfs.controller';
import { GridFsService } from './gridfs.service';

@Module({
  controllers: [GridFsController],
  providers: [GridFsService],
})
export class GridFsModule {}
