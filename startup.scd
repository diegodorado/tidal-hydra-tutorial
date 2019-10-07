(
"SC_JACK_DEFAULT_INPUTS".setenv("");
"SC_JACK_DEFAULT_OUTPUTS".setenv("");

s.options.numBuffers = 1024 * 32; // increase this if you need to load more samples
s.options.memSize = 8192 * 32; // increase this if you get "alloc failed" messages
s.options.maxNodes = 1024 * 32; // increase this if you are getting drop outs and the message "too many nodes"
s.options.numOutputBusChannels = 2; // set this to your hardware output channel size, if necessary
s.options.numInputBusChannels = 2;

s.options.maxLogins=4;


s.waitForBoot {
	~dirt = SuperDirt(2, s); // two output channels, increase if you want to pan across more channels
	~dirt.loadSoundFiles;   // load samples (path containing a wildcard can be passed in)
	s.sync;
	// load samples (path containing a wildcard can be passed in)
    ~dirt.loadSoundFiles("/home/diegodorado/Music/tidal/samples/trap-samples/*");

    s.sync; // wait for samples to be read
	~dirt.start(57120, [0, 0, 0, 0, 0, 0, 0, 0]);
    s.sync;

    n = NetAddr("127.0.0.1", 6666);
    ~dirt.startSendRMS;
    OSCFunc({ |msg|
	    defer {
            n.sendMsg("/rms", msg);
	    }
    }, "/rms");

};

s.latency = 0.2;



);



// 1. reenviar los eventos desde superdirt a hydra
(
n  = NetAddr("127.0.0.1",3333);

~dirt.receiveAction = { |e|
  if ( (e.at(\s)==\bd),
     { n.sendMsg("/bd", e.at(\cycle)); }, {}
  );
};
)


// 4. enviar los rms de los orbits desde superdirt a hydra
(
n = NetAddr("127.0.0.1", 6666);
~dirt.startSendRMS;
OSCFunc({ |msg|
    defer {
        n.sendMsg("/rms", msg);
    }
}, "/rms");
)
