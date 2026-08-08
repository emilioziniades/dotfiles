{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    llama-cpp
  ];
}
