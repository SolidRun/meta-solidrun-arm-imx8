# upstream renamed branch
SRC_URI:remove = " git://github.com/intel/${BPN};branch=master;protocol=https"
SRC_URI:append = " git://github.com/intel/${BPN};branch=main;protocol=https"
