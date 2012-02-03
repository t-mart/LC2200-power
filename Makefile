simulate: assemble
	./gt16text pow.lc

assemble: pow.s
	./gt16as pow.s

clean: 
	-rm pow.lc
	-rm pow.sym
