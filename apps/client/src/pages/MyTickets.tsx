import { useState } from "react";
import { History, Ticket } from "lucide-react";
import BookingHistory from "@/components/BookingHistory";
import { useAuth } from "@/hooks/useAuth";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import type { BookingHistoryFilter } from "@/types/profile";

type TicketTab = Extract<BookingHistoryFilter, "upcoming" | "past">;

const tabs: { id: TicketTab; label: string; icon: typeof Ticket }[] = [
  { id: "upcoming", label: "Upcoming", icon: Ticket },
  { id: "past", label: "Past", icon: History },
];

const MyTickets = () => {
  const { isLoggedIn, isInitializing } = useAuth();
  const navigate = useNavigate();
  const [tab, setTab] = useState<TicketTab>("upcoming");

  if (isInitializing) return null;
  if (!isLoggedIn) {
    navigate("/login?returnUrl=/my-tickets", { replace: true });
    return null;
  }

  return (
    <div className="container mx-auto px-4 py-8 max-w-4xl space-y-8">
      <div>
        <h1 className="text-3xl font-black tracking-tight">My Tickets</h1>
        <p className="text-muted-foreground mt-1">
          Your upcoming and past movie tickets, all in one place.
        </p>
      </div>

      <div className="inline-flex rounded-xl bg-muted/60 p-1 gap-1">
        {tabs.map((t) => (
          <button
            key={t.id}
            type="button"
            onClick={() => setTab(t.id)}
            className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-semibold transition-all duration-200 cursor-pointer ${
              tab === t.id
                ? "bg-background text-primary shadow-sm"
                : "text-muted-foreground hover:text-foreground"
            }`}
          >
            <t.icon className="w-4 h-4" />
            {t.label}
          </button>
        ))}
      </div>

      <motion.div
        key={tab}
        initial={{ opacity: 0, y: 12 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.2 }}
      >
        <BookingHistory
          filter={tab}
          title={tab === "upcoming" ? "Upcoming Tickets" : "Past Tickets"}
        />
      </motion.div>
    </div>
  );
};

export default MyTickets;
