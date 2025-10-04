import "@testing-library/jest-dom";
import { render, screen } from "@testing-library/react";

describe("Sample Test", () => {
  it("renders a deploy link", () => {
    const SampleComponent = () => <a href="#">Deploy now</a>;
    render(<SampleComponent />);

    const deployLink = screen.getByRole("link", {
      name: /deploy now/i,
    });

    expect(deployLink).toBeInTheDocument();
  });
});
