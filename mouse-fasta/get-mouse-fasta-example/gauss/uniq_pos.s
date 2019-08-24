gawk '{print $1, $2, $4}' MS4221_01u.pos > chr.pos
gawk -f profile_gausian.awk av=35 sig=3 buffer=10000 chr.pos | gawk -f chr_max_pos.awk window=35 buffer=10000 > MS4221_01un.pos
