require_relative '../lib/robotstxt'

require 'test/unit'
require 'cgi'

class TestParser < Test::Unit::TestCase
  
  def assert_disallowed(rt, p, label = "")
    assert !rt.allowed?(p), "#{p} should be disallowed #{label}"
  end

  def assert_allowed(rt, p, label = "")
    assert rt.allowed?(p), "#{p} should be allowed #{label}"
  end
  
  def test_rt1
    rt = Robotstxt::Parser.new("Test", <<-ROBOTS
user-agent: *
Allow:     /*.html$
Disallow:  /indexing/example2*
Allow:     /indexing/example.html$
Allow:     /indexing/example3.html*value3
Allow:     */indexing/*example*value2
Disallow:  ******************************************/$
Allow:     *param2*value5*
Disallow:  */exam*
Allow:     */example5$
Allow:     /indexing/exampleB/example6.html?param1=value&param2=value6
Allow:     *example6*
ROBOTS
)
    
    assert_allowed(rt, "/indexing/example.html")
    assert_allowed(rt, "/indexing/example2.html?param1=value&param2=value2")
    assert_allowed(rt, "/indexing/example3.html")
    assert_allowed(rt, "/indexing/example3.html?param1=value&param2=value3")
    assert_allowed(rt, "/indexing/example4.html")
    assert_allowed(rt, "/indexing/exampleB/example5.html")
    assert_allowed(rt, "/indexing/exampleB/example5.html?param1=value&param2=value5")
    assert_allowed(rt, "/indexing/exampleB/example5")
    assert_allowed(rt, "/indexing/exampleB/example6.html")
    assert_allowed(rt, "/indexing/exampleB/example6.html?param1=value&param2=value6")
    assert_allowed(rt, "/indexing/exampleB/example6")
    assert_disallowed(rt, "/indexing/example.html?param1=value&param2=value")
    assert_disallowed(rt, "/indexing/example/")
    assert_disallowed(rt, "/indexing/example")
    assert_disallowed(rt, "/indexing/example2.html")
    assert_disallowed(rt, "/indexing/example2/")
    assert_disallowed(rt, "/indexing/example2")
    assert_disallowed(rt, "/indexing/example3/")
    assert_disallowed(rt, "/indexing/example3")
    assert_disallowed(rt, "/indexing/example4.html?param1=value&param2=value4")
    assert_disallowed(rt, "/indexing/example4/")
    assert_disallowed(rt, "/indexing/example4")
    assert_disallowed(rt, "/indexing/exampleB/example5/")
    assert_disallowed(rt, "/indexing/exampleB/example6/")
  end
  
  def test_gb_1
    rt = Robotstxt::Parser.new("googlebot", <<-ROBOTS
User-agent: *
Allow:/men/ter*

User-agent: *
Disallow:/men/ter
ROBOTS
)
    
    assert_allowed(rt, "/men/ter")
  end
  
  def test_gb_2
    rt = Robotstxt::Parser.new("googlebot", <<-ROBOTS
User-agent: *
Allow:/men/ter*

User-agent: googlebot
Disallow:/men/ter
ROBOTS
)
    assert_disallowed(rt, "/men/ter")
  end
  
  def test_gb_3
    rt = Robotstxt::Parser.new("googlebot", <<-ROBOTS
User-agent: *
Disallow:/men/ter

User-agent: *
Allow:/men/ter*
ROBOTS
)
    assert_allowed(rt, "/men/ter")
  end
  
  def test_gbi_1
    rt = Robotstxt::Parser.new("Googlebot-Image", <<-ROBOTS
User-Agent: *
Disallow: /regulamin$

User-Agent: Googlebot
Allow: /regulamin
ROBOTS
)
    assert_allowed(rt, "/regulamin")
  end
  
  def test_gbi_2
    rt = Robotstxt::Parser.new("Googlebot-Image", <<-ROBOTS
User-Agent: Googlebot
Disallow: /regulamin$

User-Agent: Googlebot-Image
Allow: /regulamin
ROBOTS
)
    assert_allowed(rt, "/regulamin")
  end
  
  def test_gbm_1
    rt = Robotstxt::Parser.new("Googlebot-Mobile", <<-ROBOTS
User-Agent: Googlebot
Disallow: /regulamin$

User-Agent: Googlebot-Mobile
Allow: /regulamin
ROBOTS
)
    assert_allowed(rt, "/regulamin")
  end
  
  def test_mult_ua
    rt = Robotstxt::Parser.new("Googlebot", <<-ROBOTS
# robots.txt for http://www.navitor.com/
Last modified: 1/26/2011
User-agent: googlebot
User-agent: slurp
User-agent: msnbot
User-agent: teoma
User-agent: WDG_SiteValidator
User-agent: rogerbot
Disallow: /js/
Disallow: /webservices/
User-agent: Mediapartners-Google
Disallow:
User-agent: *
Disallow: /
ROBOTS
)
    assert_allowed(rt, "/")
  end
  
  
  
  
end
