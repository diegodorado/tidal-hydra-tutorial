// 1. reenviar los eventos desde superdirt a hydra

bd = 0
msg.setPort(3333)
msg.on('/bd', (args) => {
  bd = args[0]%1
})

solid(0)
.scale(()=>bd*2+1)
.out()


// 2. enviar osc desde tidal tambien a hydra
// recibiendo de tidal los mismos
// eventos que recibe superdirt
bd = 0
sn = 0
msg.setPort(9999)
msg.on('/play2', (args) => {
  o = {}
  for(let i =0;i<args.length/2;i++)
    o[args[i*2]] = args[i*2+1]
  if(o.s==="bd"){
    bd = o.cycle%1
    sn = 0
  }
  if(o.s==="sn")
    sn = o.cycle%1
})

s0.initCam()
src(s0)
.thresh(0.5)
.scrollX(()=>bd)
.scrollY(()=>sn)
.out()


// 3. enviar custom osc desde tidal a hydra
hue = 0
msg.setPort(5000)
msg.on('/hue', (args) => {
  hue = args[0]
})


solid(1,0,0).hue(()=>hue*3)
.mult(noise(5).scale(0.1).thresh(0.8))
.out()


// 4. enviar los rms de los orbits desde superdirt a hydra
for(let i= 0;i<8;i++)
  window['d'+i] = 0
msg.setPort(6666)
msg.on('/rms', (args) => {
  // ["/rms", synthID, orbitIndex, peak1, …]
  const b = Buffer.from(args[0].data);
  const i = b.readInt32BE(20)
  window['d'+i] = b.readFloatBE(24)
})

src(s0)
.thresh(0.55)
.mult(solid(0,0,1))
.scale(()=>d0+1)
.out()
