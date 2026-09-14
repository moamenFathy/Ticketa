import { motion } from "framer-motion";
import { Link } from "react-router-dom";
import logo from "../../assets/final_logo.svg";

const BrandLogo = () => {
  return (
    <motion.div
      initial={{ opacity: 0, y: -20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.8, ease: "easeOut" }}
      className="relative z-20 self-start"
    >
      <Link to="/" className="flex items-center gap-5 group">
        <motion.div
          whileHover={{ rotate: -4, scale: 1.08 }}
          transition={{ type: "spring", stiffness: 400, damping: 10 }}
        >
          <img
            src={logo}
            alt="Ticketa"
            className="h-14 w-14 object-contain drop-shadow-xl"
          />
        </motion.div>
        <div className="flex flex-col">
          <span className="text-3xl font-black tracking-tight text-foreground dark:text-white leading-none">
            TICKETA
          </span>
          <span className="text-[10px] font-bold tracking-[0.35em] text-primary uppercase mt-1.5">
            Premium Cinema
          </span>
        </div>
      </Link>
    </motion.div>
  );
};

export default BrandLogo;
