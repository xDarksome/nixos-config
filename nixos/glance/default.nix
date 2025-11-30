{pkgs, ...}: let
  markets = {
    type = "markets";
    markets = [
      { symbol = "BTC-USD"; name = "Bitcoin"; }
      { symbol = "XMR-USD"; name = "Monero"; }
    ];
  };
  search = {
    type = "search";
    search-engine = "https://leta.mullvad.net/search?q={QUERY}";
  };
  videos = {
    type = "videos";
    style = "horizontal-cards";
    channels = [
      # Gamer Nexus
      "UChIs72whgZI9w6d6FhwGGHA"
      # Economics Explained
      "UCZ4AMrDcNrfy3X6nsU8-rPg"
      # Argon
      "UCrKxBYp0AGIQLJRIFk8_ZtQ"
      # Kraut
      "UCr_Q-bPpcw5fJ-Oow1BW1NQ"
    ];
    collapse-after = -1;
  };
  rss = {
    type = "rss";
    style = "detailed-list";
    feeds = [
      {url = "https://hnrss.org/best";}
      {url = "https://hnrss.org/bestcomments";}

      {url = "https://mullvad.net/en/blog/feed/atom";}     
      {url = "https://proton.me/blog/feed";}     

      {url = "https://spectrum-os.org/lists/archives/spectrum-discuss/new.atom";}

      # {url = "https://monero.observer/feed-mini.xml";}
      {url = "https://monerica.com/rss/feed.xml";}
      {url = "https://blog.cakewallet.com/feed";}      
      {url = "https://serai.exchange/feed";}      
  
      {url = "https://kbd.news/rss2.php";}      

      {url = "https://liliputing.com/feed";}

      {url = "https://linmob.net/feed.xml";}

      {url = "https://www.nushell.sh/rss";}
    ];
    collapse-after = -1;
  };
in {
  services.glance = {
    enable = true;
    settings.server.port = 47568;

    settings.theme = {
      background-color = "50 1 6";
      primary-color = "24 97 58";
      negative-color = "209 88 54";
    };

    settings.pages = [
      {
        name = "Main";

        head-widgets = [videos];
        
        columns = [
          {
            size = "small";
            widgets = [markets];
          }
          {
            size = "full";
            widgets = [rss];
          }
        ];
      }
    ];
  };
}
