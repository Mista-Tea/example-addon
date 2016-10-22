--[[
This file will be called by both the server and the client.
This is true for any file directly inside a lua/autorun directory.
We'll use this fact to start including the addon files to their respective realms.

e.g.:
  - server files get included on the server
  - shared files get included on the server, sent to the client by the server, and then included on the client when they join
  - client files get sent to the client by the server, then included on the client when they join the server

The way this addon is structured is simple. There is an /exampleaddon folder inside the /lua folder, 
and it will hold our server, shared, and client files. These files are located inside folders called /server, /shared and /client
for simplicity so that you know what realm the files should be running in. You could name them anything you want, but it is best to
name them this way for clarity.

lua/

	autorun/
		example_addon_init.lua          <--- this is the current file!
	  
	exampleaddon/
   
		server/                         <--- this will hold all of our server files
			sv_test1.lua
		  
		shared/                         <--- this will hold all of our shared files (run by both server and client)
			sh_test2.lua     
		  
		client/                         <--- this will hold all of our client files
			cl_test3.lua

Each of the server/shared/client folders will have some files. You can also name these whatever you want, but for clarity, we prefix
them with "sv_", "sh_", and "cl_" to indicate whether they are server, shared, or client files. This doesn't do anything magical,
it's just a handy naming convention that will help when you create large addons where some of the files might have the same name
but exist in different realms (e.g., "cl_player.lua" on the client and "sv_player.lua" on the server).

So, to run these server/shared/client files, we use include() and AddCSLuaFile().
include() will actually RUN the file in the current realm (i.e., server or client). So, if we want to run the file on the server, 
we must include() the file serverside.

If we want the client to be able to run a file, we have to use AddCSLuaFile() on the SERVER first so that it gets SENT to 
the client when they join the server. Once the server AddCSLuaFile()'s the file, we just have to include() the file on the client.

The code below show how to run server, shared, and client files.
]]

if ( SERVER ) then
    -- this section of code is only run by the SERVER and gets ignored by the client   
    
    -- SERVER FILES --
    -- this file will run directly on the server
    include( "exampleaddon/server/sv_test1.lua" )
  
    -- SHARED FILES --
    -- this file will is shared, so we must not only include it on the server,
	-- but also AddCSLuaFile it so it gets sent to clients when they join the server
         include( "exampleaddon/shared/sh_test2.lua" )
    AddCSLuaFile( "exampleaddon/shared/sh_test2.lua" )
      
    -- CLIENT FILES --
    -- this file will only get SENT to the client, and will not run on the server
    AddCSLuaFile( "exampleaddon/client/cl_test3.lua" )
      
else
    -- this section of code is only run by the CLIENT
    
    -- SHARED FILES --
    -- the server sent this shared file to the client to download, so we need to manually run it
    include( "exampleaddon/shared/sh_test2.lua" )
    
    -- CLIENT FILES --
    -- similarly, this client file was sent by the server, so we also manually run it
    include( "exampleaddon/client/cl_test3.lua" )

end
