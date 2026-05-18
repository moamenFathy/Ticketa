import { getCategoryStyle } from "@/lib/utils";
import { Armchair } from "lucide-react";

interface Props {
  categories: [string, string][];
}

const Legend = ({ categories }: Props) => {
  return (
    <div className="border-t border-white/6 px-6 py-4 flex flex-wrap gap-x-6 gap-y-3">
      {/* Available per category */}
      {categories.map(([cat]) => {
        const style = getCategoryStyle(cat);
        return (
          <div key={cat} className="flex items-center gap-2 text-xs">
            <div
              className={`w-5 h-5 rounded-sm border ${style.bg} ${style.border} flex items-center justify-center`}
            >
              <Armchair className={`w-3 h-3 ${style.text}`} />
            </div>
            <span className="text-muted-foreground">{cat}</span>
          </div>
        );
      })}
      {/* Selected */}
      <div className="flex items-center gap-2 text-xs">
        <div
          className="w-5 h-5 rounded-sm border flex items-center justify-center"
          style={{
            background: "oklch(67.2% 0.191 39deg / 80%)",
            borderColor: "oklch(67.2% 0.191 39deg)",
          }}
        >
          <Armchair className="w-3 h-3 text-white" />
        </div>
        <span className="text-muted-foreground">Selected</span>
      </div>
      {/* Booked */}
      <div className="flex items-center gap-2 text-xs">
        <div className="w-5 h-5 rounded-sm border border-white/8 bg-white/4 flex items-center justify-center">
          <Armchair className="w-3 h-3 text-white/15" />
        </div>
        <span className="text-muted-foreground">Booked</span>
      </div>
    </div>
  );
};

export default Legend;
