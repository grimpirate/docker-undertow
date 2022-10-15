package com.grimpirate;

import java.nio.file.Paths;

import io.undertow.Handlers;
import io.undertow.Undertow;
import io.undertow.server.handlers.resource.PathResourceManager;

public class App
{
	public static void main(final String[] args)
	{
		Undertow
			.builder()
			.addHttpListener(Integer.parseInt(args[1]), args[0])
			.setHandler(Handlers.resource(new PathResourceManager(Paths.get(args[2]))))
			.build()
			.start();
	}
}
