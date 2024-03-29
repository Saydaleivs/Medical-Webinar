import { Controller, Get, Post, Body, Delete, Param } from '@nestjs/common';
import { CreateWebinarDto } from './webinars.dto';
import { WebinarsService } from '@/services/webinars/webinar.service';
import { Webinar } from '@/db/interface/webinar.schema';

@Controller('webinar')
export class WebinarsController {
  constructor(private readonly webinarsService: WebinarsService) {}

  @Get()
  async findAll(): Promise<Webinar[]> {
    return this.webinarsService.findAll();
  }

  @Post()
  async create(
    @Body() createWebinarDto: CreateWebinarDto,
  ): Promise<{ webinar: Webinar; notificationSeconds: number }> {
    return this.webinarsService.create(createWebinarDto);
  }

  @Delete(':webinarId')
  async delete(@Param('webinarId') webinarId: string) {
    return this.webinarsService.delete(webinarId);
  }
}
