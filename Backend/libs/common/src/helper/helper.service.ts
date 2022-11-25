import { Injectable} from '@nestjs/common';
import * as bcrypt from 'bcryptjs';


@Injectable()
export class HelperService{

    capitolizeLetter(word: string) {
        const char = word.charAt(0).toUpperCase();
        return char + word.slice(1, word.length);
    }

    async hashPassword(password: string, salt: number = 10) {
        return await bcrypt.hash(password, salt);
    }

    async compare(value: string, hash: string) {
        return await bcrypt.compare(value, hash);
    }

    makeid(length: number) {
        var result = '';
        var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        var charactersLength = characters.length;
        for (var i = 0; i < length; i++) {
            result += characters.charAt(Math.floor(Math.random() *
                charactersLength));
        }
        return result;
    }
    
}