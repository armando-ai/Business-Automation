import { MailerService } from "@nestjs-modules/mailer";
import { Inject, Injectable } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";

interface EmailOptions {
  to: string;
  subject: string;
  html: string;
}


@Injectable()
export class MailService {
  

  constructor(
    @Inject(ConfigService)
    private readonly config: ConfigService,
    @Inject(MailerService)
    private readonly mail: MailerService
  ) { }







  styles = `<style>

  *{
    margin:0 auto;
    padding:0;
    font-family:system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
    font-weight:100;
    font-size:1.2vw;
    background-color:#fff;
    color:#fff;
 }
 h1,h1,h3,p{
  margin:1vw;
  padding:1vw;
  color:#000;
 }
 div{
  height:auto;
  width:100%;
  background-color:#fff;
 }
html{
  background-color:#fff;
}
 
  </style>`;
 

  async sendUserCancellationEstimate(email: any, name: any, appt: any) {
    const date = new Date(appt.date);
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: 'Cancellation Of Appointment',
      html: `
     ${this.styles}
      <div >
  <h2>Business Automation<h2>
</div>
<div >
   <h1 class="h1">Appointment Cancellation</h1>
    <div id="cancel"></div>
   <p id="date">Date: ${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()} at ${appt.time}</p>
   <p id="userinfo">Sorry to see you cancel, ${name}</p>
   <p>You can always rebook on the calendar screen in app or web</p>
</div>`
      ,
      from: this.config.get<string>('email_username')
    });
  }
  async sendOwnerCancellationEstimate(email: any, client_name: any, appt: any, appts: any) {
    const date = new Date(appt.date);
    var arr = ``;
    var hasValues = false;
    for (let index = 0; index < appts.length; index++) {
      hasValues = true;
      const element = appts[index];
      arr+=`${element.time}, `;
      
    }
   
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: `Cancelled Appointment ${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()} at ${appt.time}`,
      html: `
      ${this.styles}
      <div >
  <h2>Business Automation<h2>
</div>
  <div >
    <h1 class="h1">Appointment Cancellation</h1>
    <p id="date">Cancelled Appointment:${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()} at ${appt.time} for ${client_name}</p>
    <p> ${hasValues ? `Remaining Bookings for the this day are at ${arr}` : 'No Bookings Remain'}</p>
     
  </div>
`
      ,
      from: this.config.get<string>('email_username')
    });
  }


  async sendUserConfirmationEmail(id: string, email: string, token: string, name: string) {

    const url = `https://businessautomation.w3spaces.com/emailconfirmation.html?id=${id}&verify_key=${token}`;
    await this.mail.sendMail({
      to: email,
      subject: 'Welcome to Business Automation, Confirm your email',
      textEncoding: 'base64',
      html: `
      ${this.styles}
      <p style="font-size:5vw">Welcome ${name}!</p>
      <p>Please click the link below to confirm your email</p>
      <p>
        <a href='${url}'>Confirm</a>
      </p>
      <p>If you did not request this email you can safely ignore it.</p>`
      ,
      from: this.config.get<string>('email_username')
    });
  }

  async sendUserConfirmationEstimate(id: string, email: string, name: string, appt: any) {
    const date = new Date(appt.date);
    if (appt['type'] == 'client_estimate') {
      appt['type'] = 'Estimate';
    } else {
      appt['type'] = 'Appointment';
    }
    const url = `https://www.w3spaces-preview.com/businessautomation/appointmentcancellation.html?id=${appt.id}`;
    await this.mail.sendMail({
      to: email,
      subject: `${appt['type']} Confirmation`,
      html: `
      ${this.styles}
      <p style="font-size:3.5vw">Confirmed for ${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()} at ${appt.time}!</p>
      <p>Thank you ${name}, we wil be there at specified time and remind the day before </p>
      <p>
        <a href='${url}'>Cancel ${appt['type']} </a>
      </p>
      <p>If you did not request this you can safely ignore it.</p>`
      ,
      from: this.config.get<string>('email_username')
    });
  }

  async sendOwnerConfirmationEstimate(email: string, name: string, appt: any) {
    const date = new Date(appt.date);
    if (appt['type'] == 'client_estimate') {
      appt['type'] = 'Estimate';
    } else {
      appt['type'] = 'Appointment';
    }
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: `${appt['type']} Confirmation`,
      html: `
      ${this.styles}
      <p style="font-size:3.5vw">Confirmed for ${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()} at ${appt.time}!</p>
      <p>${appt['type']} has been confirmed for ${name}</p>
      
      <p>Remember to be there sharp!</p>`
      ,
      from: this.config.get<string>('email_username')
    });
  }

  async sendOwnerReminder(email: string, name: string, appts: any) {
    var x = await this.getApptsInHtml(appts);
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: `Hello ${name},`,
      html: `
      ${this.styles}
        <p>There is work tomorrow scheduled these are the following Appointments</p>
        ${x}
        <p>Remember to be there sharp!</p>`
      ,
      from: this.config.get<string>('email_username')
    });
  }

  async sendClientReminder(email: string, name: string, appt: any) {

    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: `Reminder`,
      html: `
      ${this.styles}
      <h1>Hello, ${name}</h1>
      <p style="font-size:3.5vw">Tomorrow we will be there at ${appt.time}!</p>
      <p>Just an automated email, Thank you for your business.</p>
      
      <p>If chosen to cancel on short notice, please go on app be advised a cancellation fee 
      of 25% will be placed on your amount owed thank you</p>`
      ,
      from: this.config.get<string>('email_username')
    });
  }

  async getApptsInHtml(appts: any) {
    var x = `<p> Time | Name | Type </p>`;
    await appts.forEach(element => {
      if (element.type == 'client_estimate') {
        element.type = 'Estimate';
      } else {
        element.type = 'Appointment';
      }
      console.log(element);
      x += `<p>${element.time} | ${element.name} | ${element.type}</p>`;
    });
    return x;
  }

  async sendClientQuote(email: string, name: string, quote: any) {
    var rawQuote = this.getHtmlQuote(quote);
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: `Quote Response`,
      html: `
      ${this.styles}
      <h1>Hello, ${name}</h1>
      <p style="font-size:2.5vw">You have received a quote response for your pending estimate!</p>

      <h2>Quote</h2>

      ${rawQuote}
     
      
      <p>Here is the quote as well open app to respond back to Accept/Decline/Counter</p>
      <p>Just an automated email, Thank you for your business.</p>`
      ,
      from: this.config.get<string>('email_username')
    });
  }

  async sendOwnerQuote(email: string, name: string, quote: any, addy) {
    var rawQuote = this.getHtmlQuote(quote);
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: `Quote Response`,
      html: `
      ${this.styles}
      <h1>Hello, Boss</h1>
      <p style="font-size:2.5vw">You have sent ${name} a quote response for your pending estimate!</p>
      <p>Located: ${addy} </p>

      <h2>Quote</h2>
      ${rawQuote}
     
      
      <p>Here is the quote as you will be notified upon client response</p>
      <p>Just an automated email, Thank you for your business.</p>`
      ,
      from: this.config.get<string>('email_username')
    });
  }

  //client offer to owner
  async sendClientQuoteOffer(email: string, name: string, quote: any, addy) {
    var rawQuote = this.getHtmlQuote(quote);
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: `Quote Offer`,
      html: `
      ${this.styles}
      <h1>Hello, Boss</h1>
      <p style="font-size:2.5vw">You have received a offer by ${name}!</p>
      <p>Located: ${addy} </p>
      <h2>Original Quote</h2>
      ${rawQuote}

      <h3>Client Offer</h3>
      <p>Type Wanted: ${quote['offerType']}, Price: $ ${quote['offerClient']}</p>
     
      
      <p>Proceed top the app to Accept/Decline/Counter Offer</p>
      <p>Just an automated email, Thank you for your business.</p>`
      ,
      from: this.config.get<string>('email_username')
    });

  }

  //send client offer to client
  async sendClientQuoteOfferToClient(email: string, name: string, quote: any) {
    var rawQuote = this.getHtmlQuote(quote);
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: `Quote Offer`,
      html: `
      ${this.styles}
      <h1>Hello, ${name}</h1>
      <p style="font-size:2.5vw">You have sent a quote offer!</p>
     
      <h2>Original Quote</h2>
      ${rawQuote}

      <h3>Your Offer</h3>
      <p>Type Wanted: ${quote['offerType']}, Price: $ ${quote['offerClient']}</p>
     
      
      <p>You will be notified upon quote response.</p>
      <p>Just an automated email, Thank you for your business.</p>`
      ,
      from: this.config.get<string>('email_username')
    });
  }

  //owner offer to client
  async sendOwnerQuoteOffer(email: string, name: string, quote: any) {
    var rawQuote = this.getHtmlQuote(quote);
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: `Quote Offer`,
      html: `
      ${this.styles}
      <h1>Hello, ${name}</h1>
      <p style="font-size:2.5vw">You have received a counter offer on your offer!</p>

      <h2>Original Quote</h2>
      ${rawQuote}

      <h3>Your Offer</h3>
      <p>Type Wanted: ${quote['offerType']}, Price: $ ${quote['offerClient']}</p>
     
      <h3>Owner's Offer</h3>
      <p>Type Wanted: ${quote['offerType']}, Price: $ ${quote['offerOwner']}</p>
     
      
      <p>Proceed top the app to Accept/Decline/Counter Offer</p>
      <p>Just an automated email, Thank you for your business.</p>`
      ,
      from: this.config.get<string>('email_username')
    });
  }
  //owner offer to owner
  async sendOwnerQuoteOfferToOwner(email: string, name: string, quote: any, addy) {
    var rawQuote = this.getHtmlQuote(quote);
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: `Quote Offer`,
      html: `
      ${this.styles}
      <h1>Hello, Boss</h1>
      <p style="font-size:2.5vw">You have sent a quote offer!</p>
     
      <h2>Original Quote</h2>
      ${rawQuote}
      <p>Located: ${addy} </p>

      <h3>${name}'s Offer</h3>
      <p>Type Wanted: ${quote['offerType']}, Price: $ ${quote['offerClient']}</p>
     
      <h3>Your Offer</h3>
      <p>Type Wanted: ${quote['offerType']}, Price: $ ${quote['offerOwner']}</p>
     
      
      <p>You will be notified upon quote response.</p>
      <p>Just an automated email, Thank you for your business.</p>`
      ,
      from: this.config.get<string>('email_username')
    });
  }

  async AcceptedQuoteClient(email: any, name: any, quote: any) {
    var rawQuote = this.getHtmlQuote(quote);
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: `Quote Offer Accepted`,
      html: `
      ${this.styles}
      <h1>Hello, ${name}</h1>
      <p style="font-size:2.5vw">You offer has been accepted!</p>
     
  
      <h3>Accepted Offer</h3>
      <p>Type Wanted: ${quote['offerType']}, Price: $ ${quote['offerClient']}</p>
     
      
      <p>Proceed to the app and begin your initial date to repeat based off type requested.</p>
      <p>Just an automated email, Thank you for your business.</p>`
      ,
      from: this.config.get<string>('email_username')
    });
  }

  async sendAcceptedQuoteOwner(email: any, name: any, quote: any, addy: any) {
    var rawQuote = this.getHtmlQuote(quote);
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: `Quote Offer Accepted`,
      html: `
      ${this.styles}
      <h1>Hello, Boss</h1>
      <p style="font-size:2.5vw">You accepted a quote offer!</p>
     
      <h2>Clients Name: ${name}</h3>
      <p>Located: ${addy} </p>
      <h3>Accepted Offer</h3>
      <p>Type Wanted: ${quote['offerType']}, Price: $ ${quote['offerClient']}</p>
     
      
      <p>You will be notified upon begin of service as well as dates.</p>
      <p>Just an automated email, Thank you for your business.</p>`
      ,
      from: this.config.get<string>('email_username')
    });
  }

  async newClient(email: any, name: any, type: any, dates: any, price: any, location: any) {
    var rawDates = this.getNewBookings(dates);
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: `New Client`,
      html: `
      ${this.styles}
      <h1>Hello, Boss</h1>
      <p style="font-size:2.5vw">${name} is now a new client!</p>
      <p>Type Wanted: ${type}, Price: $ ${price}</p>
     <p>Location:${location}</p>
  
      <h3>You have automated a whole year of service</h3>
      ${rawDates}
      
     
      
      <p>If ever chosen to cancel you can on the app</p>
      <p>Just an automated email, Thank you for your business.</p>`
      ,
      from: this.config.get<string>('email_username')
    });
  }

  async clientBooked(email: any, name: any, type: any, dates: any, automated: any, price: any) {
    var rawDates = this.getNewBookings(dates);
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: `Booked For the Year`,
      html: `
      ${this.styles}
      <h1>Hello, ${name}</h1>
      <p style="font-size:2.5vw">You have booked with Business Automation!</p>
      <p>Type Wanted: ${type}, Price: $ ${price}</p>
     
  
      <h3>You have automated a whole year of service</h3>
      ${rawDates}
      
     
      
      <p>If ever chosen to cancel you can on the app</p>
      <p>Just an automated email, Thank you for your business.</p>`
      ,
      from: this.config.get<string>('email_username')
    });
  }

  async ownerDecline(email: any, name: any, type: any, price: any, quote: any) {

    var rawQuote = this.getHtmlQuote(quote);
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: `Owner has declined your offer`,
      html: `
      ${this.styles}
      <h1>Hello, ${name}</h1>
      <p style="font-size:2.5vw">Your quote offer has been declined!</p>
     
      <h3>Original Quote</h3>
      ${rawQuote}
      <h3>Your Offer</h3>
      <p>Type Wanted: ${quote['offerType']}, Price: $ ${quote['offerClient']}</p>
     
      
      <p>Your offer has been declined you can send another offer or uninstall the app thank you.</p>
      <p>Just an automated email, Thank you for your business.</p>`
      ,
      from: this.config.get<string>('email_username')
    });
  }

  async ownerDeclinedCopy(email: any, name: any, type: any, price: any, addy: any, quote: any) {

    var rawQuote = this.getHtmlQuote(quote);
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: `You have declined an offer`,
      html: `
      ${this.styles}
      <h1>Hello, ${name}</h1>
      <p style="font-size:2.5vw">You declined ${name}'s Offer!</p>
      <p>Located: ${addy} </p>
      <h3>Original Quote</h3>
      ${rawQuote}
      <h3>${name}'s Offer</h3>
      <p>Type Wanted: ${quote['offerType']}, Price: $ ${quote['offerClient']}</p>
     
      
      <p>You declined the offer will no longer display in pending quotes until client send another offer.</p>
      <p>Just an automated email, Thank you for your business.</p>`
      ,
      from: this.config.get<string>('email_username')
    });
  }

  async declinedClient(email: any, name: any, type: any, price: any, quote: any) {

    var rawQuote = this.getHtmlQuote(quote);
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: `You have declined quote`,
      html: `
      ${this.styles}
      <h1>Hello, ${name}</h1>
      <p style="font-size:2.5vw">You have declined the quote!</p>
     
      <h3>Original Quote</h3>
      ${rawQuote}
     
      
      <p>You have declined you can send another offer or uninstall the app thank you.</p>
      <p>Just an automated email, Thank you for your business.</p>`
      ,
      from: this.config.get<string>('email_username')
    });
  }

  async declinedClientCopy(email: any, name: any, type: any, price: any, addy: any, quote: any) {

    var rawQuote = this.getHtmlQuote(quote);
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: `Quote has been declined`,
      html: `
      ${this.styles}
      <h1>Hello, Boss</h1>
      <p style="font-size:2.5vw">${name} has declined your quote!</p>
      <p>Located: ${addy} </p>
      <h3>Original Quote</h3>
      ${rawQuote}
     
      
      <p>Owner has declined the offer, will no longer display in pending quotes until client sends another offer</p>
      <p>Just an automated email, Thank you for your business.</p>`
      ,
      from: this.config.get<string>('email_username')
    });
  }
  async clientTerminationCopy(email: any, name: any) {
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: `You have terminated business service`,
      html: `
      ${this.styles}
      <h1>Hello, ${name}</h1>
      <p style="font-size:2.5vw">You have cancelled all appointments!</p>
     
      
     
      
      <p>Sorry to see you cancel you can always rebook in app or web.</p>
      <p>Just an automated email, Thank you for your business.</p>`
      ,
      from: this.config.get<string>('email_username')
    });
  }
  async ownerTerminateCopy(email: any, name: any, addy: any) {
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: `${name} has terminated business service`,
      html: `
      ${this.styles}
      <h1>Hello, Boss</h1>
      <p style="font-size:2.5vw">${name} has cancelled all appointments!</p>
     
      
     
      
      <p>You can view updated schedule in the calendar section all slots have been deleted for said client</p>
      <p>Just an automated email, Thank you for your business.</p>`
      ,
      from: this.config.get<string>('email_username')
    });
  }

  getNewBookings(dates) {
    var allDates = ``;
    for (let index = 0; index < dates.length; index++) {
      const element = dates[index];
      const date = new Date(element.date);
      allDates += `  <p style="font-size:3.5vw">${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()} at ${element.time}!</p>`;
    }
    return allDates;
  }

  getHtmlQuote(quote: any) {
    return `<p>Weekly: $ ${quote['weekly']}</p><p>BiWeekly: $ ${quote['biweekly']}</p><p>TriWeekly: $ ${quote['triweekly']}</p><p>Monthly: $ ${quote['monthly']}</p><p>Initial/Once: $ ${quote['initial']}</p>`;
  }




  async ownerCancel(email: any, name: any, appt: any, available) {
    const date = new Date(appt.date);

    const slots = await getAvailableHtml(available);
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: 'Cancellation Of Appointment',
      html: `
     ${this.styles}
      <div >
  <h2>Business Automation<h2>
</div>
<div >
   <h1 class="h1">Appointment Cancellation</h1>
    <div id="cancel"></div>
   <p id="date">Date: ${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()} at ${appt.time}</p>
   <p id="userinfo">Sorry for the short notice we wont be able to make it, ${name}. We will provide our next available dates below</p>
   <h3>Available Dates</h3>
   ${slots}
   <p>You can always rebook on the calendar screen in app or web</p>
</div>`
      ,
      from: this.config.get<string>('email_username')
    });
  }

  async ownerCancelCopy(email: any, client_name: any, appt: any, appts: any) {
    const date = new Date(appt.date);
    var arr = ``;
    var hasValues = false;
    for (let index = 0; index < appts.length; index++) {
      hasValues = true;
      const element = appts[index];
      arr+=`${element.time}, `;
      
    }
    await this.mail.sendMail({
      to: email,
      textEncoding: 'base64',
      subject: `Cancelled Appointment ${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()} at ${appt.time}`,
      html: `
      ${this.styles}
    <div >
      <h2>Business Automation<h2>
    </div>
    <div >
    <h1 class="h1">You cancelled on a client</h1>
    <p id="date">Cancelled Appointment:${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()} at ${appt.time} for ${client_name}</p>
    <p> ${hasValues ? `Remaining Bookings for the this day are at ${arr}` : 'No Bookings Remain'}</p>
    </div>
`
      ,
      from: this.config.get<string>('email_username')
    });
  }

}



async function getAvailableHtml(available: any) {
  let availableDates = ``;
  available.forEach(element => {
    const date = new Date(element.date);
    availableDates+=`  <p id="date">Date:${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()}, TimeSlots: `;
    element.time_slots.forEach(slots => {
      availableDates+=`${slots},`;
    });
    availableDates+=`</p>`;
  });
  return availableDates;
}

