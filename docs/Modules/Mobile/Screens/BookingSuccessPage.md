# Mobile Screen Deep-Dive: `BookingSuccessPage`

> **File Path:** `apps/mobile/lib/features/payment/presentation/screens/booking_success_page.dart`  
> **Route Type:** Imperative MaterialPageRoute  
> **Parameters:** `bookingDetails: BookingDetailsDto` (or booking reference)  
> **Visual Features:** Perforated ticket stub UI, vector QR code generator

---

## 1. Overview & Business Objectives

`BookingSuccessPage` is the confirmation screen shown after a ticket purchase:
1. **Celebratory Confirmation:** Animated green checkmark with haptic feedback.
2. **Digital Ticket Stub (`TicketCard`):** Perforated edges, notch cutouts, cinema name, screening date/time, hall, seat numbers, and booking reference.
3. **Contactless QR Code:** High-density vector QR code generated via `qr_flutter` for immediate gate scanning at the cinema.
4. **Quick Navigation:** Direct actions to view all tickets in wallet (`MyTicketsPage`) or return to discovery feed.

---

## 2. Screen Architecture & Composition

```mermaid
graph TD
    Screen[BookingSuccessPage] --> Scroll[SingleChildScrollView]
    
    Scroll --> SuccessIcon[Animated Success Checkmark + 'Booking Confirmed!']
    Scroll --> TicketStub[TicketCard: Perforated Cinema Pass]
    
    TicketStub --> PosterTitle[Movie Poster + Title + Hall Type]
    TicketStub --> Timing[Date: YYYY-MM-DD | Time: HH:mm]
    TicketStub --> Seats[Seats: R1-S4, R1-S5]
    TicketStub --> QR[Vector QR Code: qr_flutter with Booking Reference]
    
    Scroll --> Actions[Action Buttons]
    Actions --> ViewAll[View My Tickets -> Navigate /my-tickets]
    Actions --> BackHome[Back to Home -> Navigate /main]
```
