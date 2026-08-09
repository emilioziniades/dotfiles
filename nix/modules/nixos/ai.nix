{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    llama-cpp-vulkan
    pi-coding-agent
  ];
}
