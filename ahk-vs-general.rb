filename = ARGV[0]

#Require LogSeriesParser
require 'log_series_file.rb'

blank = MatchProperties.new

#This set is for Virtual Sensor Overall Statistics


# entry regex
logstart = LogRegexp.new(MatchProperties.new(MatchType::SET,""),/isss15# show clock/)

#section regex's
vs = LogRegexp.new(MatchProperties.new(MatchType::SUBSECTION,"vs"),/\w*Statistics for Virtual Sensor (?<vs>vs\d)/)

#parsing regex's
time = LogRegexp.new(blank,/(\.|)(?<time>\d[^G]*GMT-06:00.*)/)
ssr = LogRegexp.new(blank,/\w*Number of seconds since a reset of the statistics = (?<ssr>\d+)/)
memused = LogRegexp.new(blank,/MemoryUsedPercent = (?<Memory Used>\d+)/)
procload = LogRegexp.new(blank,/Processing Load Percentage = (?<Processor Load>\d+)/)
tot_pack = LogRegexp.new(blank,/Total packets processed since reset = (?<Total Packets>\d+)/)
tcp_pack = LogRegexp.new(blank,/Total TCP packets processed since reset = (?<TCP Packets>\d+)/)
udp_pack = LogRegexp.new(blank,/Total UDP packets processed since reset = (?<UDP Packets>\d+)/)
icmp_pack = LogRegexp.new(blank,/Total ICMP packets processed since reset = (?<ICMP Packets>\d+)/)
other_pack = LogRegexp.new(blank,/Total packets that were not TCP, UDP, or ICMP processed since reset = (?<Other Packets>\d+)/)
tot_bytes = LogRegexp.new(blank,/Total number of bytes processed since reset = (?<Total Bytes>\d+)/)
pps = LogRegexp.new(blank,/The rate of packets per second since reset = (?<Pps>\d+)/)
bps = LogRegexp.new(blank,/The rate of bytes per second since reset = (?<Bps>\d+)/)
bpp = LogRegexp.new(blank,/The average bytes per packet since reset = (?<BpP>\d+)/)

#TCP Stream Parsing
tcp_tracked = LogRegexp.new(blank,/TCP streams that have been tracked since last reset = (?<TCP Streams Tracked>\d+)/)
tcp_seq_gaps = LogRegexp.new(blank,/TCP streams that had a gap in the sequence jumped = (?<TCP Sequence Gaps>\d+)/)
tcp_ab_gap = LogRegexp.new(blank,/TCP streams that was abandoned due to a gap in the sequence = (?<TCP Abandoned - Gap>\d+)/)
tcp_oo_seq = LogRegexp.new(blank,/TCP packets that arrived out of sequence order for their stream = (?<TCP Out of Seq>\d+)/)
tcp_oo_state = LogRegexp.new(blank,/TCP packets that arrived out of state order for their stream = (?<TCP Out of State>\d+)/)
tcp_ps = LogRegexp.new(blank,/The rate of TCP connections tracked per second since reset = (?<TCP Tracked per sec>\d+)/)


#Sigevent Parsing
alerts_fired = LogRegexp.new(blank,/Number of Alerts received = (?<Alerts Fired>\d+)/)

file_to_parse = LogSeriesFile.open(filename)

file_to_parse.log_series_parse(logstart,vs,time,ssr,memused,procload,tot_pack,tcp_pack,udp_pack,icmp_pack,other_pack,tot_bytes,pps,bps,bpp,tcp_tracked,tcp_seq_gaps,tcp_ab_gap,tcp_oo_seq,tcp_oo_state,tcp_ps,alerts_fired)