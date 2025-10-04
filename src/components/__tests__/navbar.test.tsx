import { render, screen } from "@testing-library/react";
import { Navbar } from "../navbar";

describe("Navbar", () => {
  it("renders navigation links and a call to action", () => {
    render(<Navbar />);

    // Check for navigation links
    expect(screen.getByRole("link", { name: /home/i })).toBeInTheDocument();
    expect(screen.getByRole("link", { name: /about/i })).toBeInTheDocument();
    expect(screen.getByRole("link", { name: /programs/i })).toBeInTheDocument();
    expect(screen.getByRole("link", { name: /contact/i })).toBeInTheDocument();

    // Check for the "Donate Now" button
    expect(
      screen.getByRole("link", { name: /donate now/i }),
    ).toBeInTheDocument();
  });
});
