import { PartialType } from '@nestjs/mapped-types';
import { BusinessOwner, CreateUserDto } from './create-user.dto';

export class UpdateUserDto extends PartialType(CreateUserDto) {
  id: string;
}
export class UpdateOwnerDto extends PartialType(BusinessOwner) {
  id: string;
}