//
//  File.swift
//  
//
//  Created by Shilpee Gupta on 10/01/23.
//


import VaporBackend
import Vapor

print("""
      ★*ﾟ*☆*ﾟ*★*ﾟ*☆*ﾟ*★★*ﾟ*☆*ﾟ*★*ﾟ*☆*ﾟ*★★*ﾟ*☆*ﾟ*★*ﾟ*☆*ﾟ*★
      This is the server for ChitChat iOS App.
      ★*ﾟ*☆*ﾟ*★*ﾟ*☆*ﾟ*★★*ﾟ*☆*ﾟ*★*ﾟ*☆*ﾟ*★★*ﾟ*☆*ﾟ*★*ﾟ*☆*ﾟ*★
""")


var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()
