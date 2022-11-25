import { Days } from "@prisma/client";

export class CreateUserDto {
    name: string;
    email: string;
    password: string;
    role: string;
    address: {
        street: string;
        suite?: string;
        city: string;
        state: string;
        zip: string;
    } 
    refresh_token?: string
    verify_key: string;
    verified: boolean;
    updatePassword: boolean;
}
export class CreateClientDto {
    user: CreateUserDto;
}
export class BusinessOwner {
    user?: CreateUserDto;
    estimatePreferences?: EstimateDayPreference[];
    excluded_Days:string[];
}

export class EstimateDayPreference {
    day: Days
    from: string;
    to: string;
}
export class EstimateDaySlot {
    day: Days
    time_slots?:[];
}