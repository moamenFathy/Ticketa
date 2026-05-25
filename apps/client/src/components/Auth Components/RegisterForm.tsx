import { motion } from "framer-motion";
import type { Variants } from "framer-motion";
import { Link } from "react-router-dom";
import { Button } from "../ui/button";
import {
  ArrowRight,
  CalendarDays,
  Loader2,
  Lock,
  Mail,
  Sparkles,
} from "lucide-react";
import ErrorBanner from "./ErrorBanner";
import {
  Field,
  FieldError,
  FieldGroup,
  FieldLabel,
  FieldSet,
} from "../ui/field";
import PasswordToggle from "./PasswordToggle";
import { Input } from "../ui/input";
import PasswordStrength from "./PasswordStrength";
import type { ApiError } from "@/types/api";
import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import { useState } from "react";
import { useRegister } from "@/hooks/useAuth";
import z from "zod";
import SuccessCheckmark from "./SuccessCheckmark";
import { Popover, PopoverContent, PopoverTrigger } from "../ui/popover";
import { Calendar } from "../ui/calendar";
import { format, parse } from "date-fns";
import { cn } from "@/lib/utils";

const formSchema = z
  .object({
    email: z
      .string()
      .min(1, "Email is required")
      .email("Invalid email address"),
    dateOfBirth: z
      .string()
      .min(1, "Date of birth is required")
      .regex(/^\d{4}-\d{2}-\d{2}$/, "Use format YYYY-MM-DD")
      .refine(
        (val) => {
          const date = new Date(val);
          if (isNaN(date.getTime())) return false;
          const age = new Date().getFullYear() - date.getFullYear();
          return age >= 5 && age <= 150;
        },
        { message: "You must be at least 5 years old" },
      ),
    password: z
      .string()
      .min(1, "Password is required")
      .min(8, "Password must be at least 8 characters"),
    confirmPassword: z.string().min(1, "Please confirm your password"),
  })
  .refine((data) => data.password === data.confirmPassword, {
    message: "Passwords do not match",
    path: ["confirmPassword"],
  });

type FormValues = z.infer<typeof formSchema>;

const iconClass = (error?: string, isTouched?: boolean) => {
  if (error && isTouched) return "text-destructive";
  if (isTouched && !error) return "text-emerald-500";
  return "text-muted-foreground/30";
};

const errorBorderClass = (error?: string, isTouched?: boolean) => {
  if (error && isTouched)
    return "border-destructive/60 focus:border-destructive focus:ring-4 focus:ring-destructive/10";
  return "border-border/50 hover:border-border focus:border-primary/60 focus:ring-4 focus:ring-primary/8";
};

const RegisterForm = ({
  onSuccess,
}: {
  onSuccess: (email: string) => void;
}) => {
  const { mutate: register, isPending, error } = useRegister();
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    mode: "onBlur",
    defaultValues: {
      email: "",
      dateOfBirth: "",
      password: "",
      confirmPassword: "",
    },
  });

  const { errors, touchedFields } = form.formState;
  const apiError = error as ApiError | null;

  const onSubmit = (values: FormValues) => {
    register(
      {
        email: values.email,
        password: values.password,
        dateOfBirth: values.dateOfBirth,
      },
      { onSuccess: () => onSuccess(values.email) },
    );
  };

  const fieldVariants: Variants = {
    hidden: { opacity: 0, y: 16 },
    visible: (i: number) => ({
      opacity: 1,
      y: 0,
      transition: { delay: i * 0.08, duration: 0.4, ease: "easeOut" },
    }),
  };

  return (
    <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
      <motion.div
        initial="hidden"
        animate="visible"
        variants={{ hidden: {}, visible: {} }}
        className="space-y-4"
      >
        <FieldSet>
          <FieldGroup>
            {/* Email */}
            <motion.div custom={0} variants={fieldVariants}>
              <Field
                data-invalid={!!errors.email}
                data-disabled={isPending || undefined}
              >
                <FieldLabel
                  htmlFor="email"
                  className="text-[11px] font-bold text-muted-foreground/60 uppercase tracking-[0.15em]"
                >
                  Email Address
                </FieldLabel>
                <div className="relative">
                  <Mail
                    className={`absolute left-4 top-1/2 -translate-y-1/2 h-4.5 w-4.5 z-10 transition-colors ${iconClass(errors.email?.message, touchedFields.email)}`}
                  />
                  <Input
                    id="email"
                    placeholder="you@example.com"
                    autoComplete="email"
                    autoFocus
                    disabled={isPending}
                    className={`h-14 pl-12 pr-4 rounded-2xl text-sm shadow-xs transition-all duration-300 ${errorBorderClass(errors.email?.message, touchedFields.email)}`}
                    {...form.register("email")}
                  />
                  <SuccessCheckmark
                    show={
                      !!touchedFields.email &&
                      !errors.email &&
                      form.watch("email").length > 0
                    }
                  />
                </div>
                <FieldError
                  errors={errors.email ? [errors.email] : undefined}
                />
              </Field>
            </motion.div>

            {/* Date of Birth */}
            <motion.div custom={1} variants={fieldVariants}>
              <Field
                data-invalid={!!errors.dateOfBirth}
                data-disabled={isPending || undefined}
              >
                <FieldLabel
                  htmlFor="dateOfBirth"
                  className="text-[11px] font-bold text-muted-foreground/60 uppercase tracking-[0.15em]"
                >
                  Date of Birth
                </FieldLabel>
                <div className="relative">
                  <CalendarDays
                    className={`absolute left-4 top-1/2 -translate-y-1/2 h-4.5 w-4.5 z-10 transition-colors ${iconClass(errors.dateOfBirth?.message, touchedFields.dateOfBirth)}`}
                  />
                  <Popover>
                    <PopoverTrigger asChild>
                      <Button
                        variant="outline"
                        type="button"
                        disabled={isPending}
                        className={cn(
                          "w-full h-14 pl-12 pr-4 rounded-2xl text-sm font-normal text-left shadow-xs transition-all duration-300 border-border/50 hover:border-border focus:border-primary/60 focus:ring-4 focus:ring-primary/8",
                          !form.watch("dateOfBirth") &&
                            "text-muted-foreground/40",
                          errorBorderClass(
                            errors.dateOfBirth?.message,
                            touchedFields.dateOfBirth,
                          ),
                        )}
                      >
                        {form.watch("dateOfBirth") ? (
                          format(
                            parse(
                              form.watch("dateOfBirth"),
                              "yyyy-MM-dd",
                              new Date(),
                            ),
                            "PPP",
                          )
                        ) : (
                          <span>Select your birthday</span>
                        )}
                      </Button>
                    </PopoverTrigger>
                    <PopoverContent
                      className="w-auto p-0 rounded-2xl overflow-hidden shadow-2xl border-border/40"
                      align="start"
                    >
                      <Calendar
                        mode="single"
                        captionLayout="dropdown"
                        startMonth={new Date(1900, 0)}
                        endMonth={new Date()}
                        selected={
                          form.watch("dateOfBirth")
                            ? parse(
                                form.watch("dateOfBirth"),
                                "yyyy-MM-dd",
                                new Date(),
                              )
                            : undefined
                        }
                        onSelect={(date) => {
                          if (date) {
                            form.setValue(
                              "dateOfBirth",
                              format(date, "yyyy-MM-dd"),
                              {
                                shouldValidate: true,
                                shouldTouch: true,
                              },
                            );
                          }
                        }}
                        disabled={(date) =>
                          date > new Date() || date < new Date("1900-01-01")
                        }
                      />
                    </PopoverContent>
                  </Popover>
                  <SuccessCheckmark
                    show={
                      !!touchedFields.dateOfBirth &&
                      !errors.dateOfBirth &&
                      form.watch("dateOfBirth").length > 0
                    }
                  />
                </div>
                <FieldError
                  errors={errors.dateOfBirth ? [errors.dateOfBirth] : undefined}
                />
              </Field>
            </motion.div>

            {/* Password */}
            <motion.div custom={2} variants={fieldVariants}>
              <Field
                data-invalid={!!errors.password}
                data-disabled={isPending || undefined}
              >
                <div className="flex items-center justify-between">
                  <FieldLabel
                    htmlFor="password"
                    className="text-[11px] font-bold text-muted-foreground/60 uppercase tracking-[0.15em]"
                  >
                    Password
                  </FieldLabel>
                  <span className="text-[10px] font-medium text-muted-foreground/50">
                    Min 8 characters
                  </span>
                </div>
                <div className="relative">
                  <Lock
                    className={`absolute left-4 top-1/2 -translate-y-1/2 h-4.5 w-4.5 z-10 transition-colors ${iconClass(errors.password?.message, touchedFields.password)}`}
                  />
                  <Input
                    id="password"
                    type={showPassword ? "text" : "password"}
                    placeholder="Create a strong password"
                    autoComplete="new-password"
                    disabled={isPending}
                    className={`h-14 pl-12 pr-12 rounded-2xl text-sm shadow-xs transition-all duration-300 ${errorBorderClass(errors.password?.message, touchedFields.password)}`}
                    {...form.register("password")}
                  />
                  <PasswordToggle
                    show={showPassword}
                    onToggle={() => setShowPassword(!showPassword)}
                  />
                </div>
                <FieldError
                  errors={errors.password ? [errors.password] : undefined}
                />
                <PasswordStrength password={form.watch("password")} />
              </Field>
            </motion.div>

            {/* Confirm Password */}
            <motion.div custom={3} variants={fieldVariants}>
              <Field
                data-invalid={!!errors.confirmPassword}
                data-disabled={isPending || undefined}
              >
                <FieldLabel
                  htmlFor="confirmPassword"
                  className="text-[11px] font-bold text-muted-foreground/60 uppercase tracking-[0.15em]"
                >
                  Confirm Password
                </FieldLabel>
                <div className="relative">
                  <Lock
                    className={`absolute left-4 top-1/2 -translate-y-1/2 h-4.5 w-4.5 z-10 transition-colors ${iconClass(errors.confirmPassword?.message, touchedFields.confirmPassword)}`}
                  />
                  <Input
                    id="confirmPassword"
                    type={showConfirmPassword ? "text" : "password"}
                    placeholder="Re-enter your password"
                    autoComplete="new-password"
                    disabled={isPending}
                    className={`h-14 pl-12 pr-12 rounded-2xl text-sm shadow-xs transition-all duration-300 ${errorBorderClass(errors.confirmPassword?.message, touchedFields.confirmPassword)}`}
                    {...form.register("confirmPassword")}
                  />
                  <PasswordToggle
                    show={showConfirmPassword}
                    onToggle={() =>
                      setShowConfirmPassword(!showConfirmPassword)
                    }
                  />
                </div>
                <FieldError
                  errors={
                    errors.confirmPassword
                      ? [errors.confirmPassword]
                      : undefined
                  }
                />
              </Field>
            </motion.div>
          </FieldGroup>
        </FieldSet>
      </motion.div>

      <ErrorBanner message={apiError?.message || null} />

      <motion.div
        initial={{ opacity: 0, y: 16 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.35, duration: 0.4 }}
        className="pt-1 space-y-4"
      >
        <Button
          type="submit"
          className="w-full h-13 bg-primary hover:bg-primary/90 text-primary-foreground font-black text-base rounded-2xl active:scale-[0.98] shadow-[0_8px_28px_rgba(var(--primary),0.25)] hover:shadow-[0_12px_36px_rgba(var(--primary),0.35)] overflow-hidden relative group transition-all duration-300"
          disabled={isPending}
        >
          <div className="absolute inset-0 bg-linear-to-r from-transparent via-white/15 to-transparent -translate-x-full group-hover:translate-x-full transition-transform duration-1000" />
          {isPending ? (
            <span className="flex items-center justify-center gap-2.5">
              <Loader2 className="h-5 w-5 animate-spin" />
              <span>Creating account...</span>
            </span>
          ) : (
            <span className="flex items-center justify-center gap-2.5">
              <Sparkles className="h-4.5 w-4.5" />
              <span>Create Account</span>
              <ArrowRight className="h-4.5 w-4.5 group-hover:translate-x-1 transition-transform" />
            </span>
          )}
        </Button>

        <p className="text-sm text-center text-muted-foreground/70 font-medium">
          Already have an account?{" "}
          <Link
            to="/login"
            className="text-foreground font-black hover:text-primary transition-colors uppercase tracking-[0.08em] text-[11px]"
          >
            Sign In
          </Link>
        </p>
      </motion.div>
    </form>
  );
};

export default RegisterForm;
