import Config

config :ten_ex_take_home, :marvel_client,
  public_key: System.get_env("MARVEL_API_PUBLIC_KEY"),
  private_key: System.get_env("MARVEL_API_PRIVATE_KEY")
