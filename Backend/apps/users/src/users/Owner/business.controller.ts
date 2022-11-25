import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, Request } from '@nestjs/common';

import { BusinessService } from './business.service';
import { UpdateUserDto, BusinessOwner} from '@app/common';
import { Public } from 'apps/auth/src/decorators/public.decorator';

@Controller('owner')
export class BusinessController {
  constructor(private readonly businessService: BusinessService) {}

  @Public()
  @Post('register')
  async create(@Body() createUserDto: BusinessOwner) {
    return await this.businessService.create(createUserDto);
  }


//   @Public()
//   @Get()
//   async findAll() {
//     return await thbusines.findAll();
//   }

  @Post('ownerByUserId/:id')
  async findOne(@Param('id') id: string) {
    return await this.businessService.findByUserId(id);
  }

  @Patch('update/preferences/:id')
  async updatePref(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {
    return await this.businessService.updatePref(id, updateUserDto);
  }

  @Patch('update/preferences/excluded/:id')
  async verify(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {

    return await this.businessService.updateExcluded(id, updateUserDto);
  }

//   @Delete(':id')
//   async remove(@Param('id') id: string) {
//     return await thbusines.remove(id);
//   }

}
