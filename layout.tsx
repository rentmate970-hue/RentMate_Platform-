import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "RentMate — Meet. Connect. Experience.",
  description: "Dating, friendship and non-sexual social companionship for adults.",
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="en"><body>{children}</body></html>;
}
