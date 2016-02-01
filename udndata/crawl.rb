sleepTime = 3
keywords = Array.new
#keywords.push "\u540C\u6027\u6200"  # 同性戀
keywords.push "\u540C\u5FD7"        # 同志
keywords.push "\u73BB\u7483\u5708"  # 玻璃圈
keywords.push "\u65B7\u80CC"        # 斷背
keywords.push "\u9177\u5152"        # 酷兒

require "watir-webdriver"
$pwd = Dir.pwd

keywords.each do |keyword|
    puts keyword
    if(!Dir.exists?(keyword)) then
        Dir.mkdir(keyword)
    end
    Dir.chdir(keyword)

    for $year in [1996,1997].concat((2000..2011).to_a)
        $links = Array.new
        $hash = Hash.new
        $hash.default = 0
        if(!Dir.exists?($year.to_s)) then
            Dir.mkdir($year.to_s)
        end
        startdate = $year.to_s.concat("0101")
        enddate = $year.to_s.concat("1231")

        sleep sleepTime
        $browser = Watir::Browser.start "http://udndata.com/library", :chrome
        $frame = $browser.frames[1]
        $frame.text_field(:name => "SearchString").set keyword
        $frame.text_field(:name => "day2").set startdate
        $frame.text_field(:name => "day3").set enddate
        $frame.img(:src => "/images/newdata/images_2007/refer_all_c.gif", :index => 0).click
        $frame.img(:src => "/images/newdata/images_2007/refer_all_c.gif", :index => 1).click
        $frame.checkbox(:name => "d1").set
        $frame.checkbox(:name => "d6").set
        $frame.select(:name => "sharepage").select("50")
        $frame.button(:name => "submit").click

        if($frame.strongs[0].fonts[3].text.to_i == 0) then
            next
        end

        $frame.as(:href => /ndapp\/Story2007/).each do |a|
            $links.push a.href
        end
        begin
            if($frame.a(:text => "\u4E0B\u4E00\u9801").exists?) then
                sleep sleepTime
                $frame.a(:text => "\u4E0B\u4E00\u9801").click
            else
                break
            end
            $frame.as(:href => /ndapp\/Story2007/).each do |a|
                $links.push a.href
            end
        end while $frame.a(:href => /ndapp\/Story2007/).exists?
        puts $links.size.to_s + " links in " + $year.to_s

        total = 0
        $log = File.open("log" + $year.to_s + ".csv", "a")
        $links.each do |link|
            sleep sleepTime
            if((total % 200) == 0) then
                $browser.close
                $browser = Watir::Browser.start "http://udndata.com/library", :chrome
            end
            $browser.goto link

            counter = 0
            news_id = link.split("&")[8].split("=")[1]
            while !$browser.td(:class => "story").exists? || $browser.td(:class => "story").text.split("\n").size < 2
                puts "Empty response, wait.."
                sleep (sleepTime * 5)
                $browser.goto link
            end
            header = $browser.span(:class => "story_title").parent.parent.parent.parent.text
            content = $browser.td(:class => "story").text
            date = content.split("\n").last[1,10]

            pos = 0
            while(pos = header.index(keyword, pos + 1))
                counter += 1
                total += 1
            end
            pos = 0
            while(pos = content.slice(0, content.rindex("\n")).index(keyword, pos + 1))
                counter += 1
                total += 1
            end

            $hash[date] += counter
            $log.write date + ",\t" + counter.to_s + ",\t" + news_id + "\n"
            File.open($year.to_s + "/" + date + "_" + news_id + "_" + counter.to_s + ".txt", "w") do |file|
                file.write link # http://udndata.com/ndapp/Story2007?no=1&SearchString=plCn0yuk6bTBPj0yMDEwMDIyNSuk6bTBPD0yMDEwMDIyNSuz%2BKdPPcFwpliz%2BHzBcKZYsd%2Bz%2BA%3D%3D&sharepage=10&news_id=5271729
                file.write "\r\n"
                file.write header
                file.write "\r\n\r\n"
                file.write content
            end
        end

        puts total.to_s + " occurences in " + $links.size.to_s + " links in " + $year.to_s
        $log.close

        File.open("statistics" + $year.to_s + ".csv", "a") do |file|
            $hash.each do |date, count|
                file.write date + ",\t" + count.to_s + "\n"
            end
        end
    end

    Dir.chdir $pwd
end

$browser.close