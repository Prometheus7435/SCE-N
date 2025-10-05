{ ... }: {
  console.keyMap = "us";
  # time.timeZone = "America/New_York";

  services = {
    automatic-timezoned.enable = true;  # dynamic timezone
  };
}
