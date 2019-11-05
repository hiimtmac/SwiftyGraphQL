Pod::Spec.new do |s|
    
    s.name                    = "SwiftyGraphQL"
    s.version                 = "0.9.2"
    s.summary                 = "Typesafe(er) helpers for creating graphql queries & mutations"
    s.description             = <<-DESC
                                This small library helps to create typesafe(er) mutations & queries for use with graphql.
                                These objects can then be `codable-d` and used in `URLSession`s
                                DESC
    
    s.homepage                = "http://github.com/hiimtmac/SwiftyGraphQL"
    s.license                 = { :type => "MIT", :file => "LICENSE" }
    
    s.author                  = "Taylor McIntyre"
    s.social_media_url        = "http://twitter.com/hiimtmac"
    s.ios.deployment_target   = "11.0"
    s.swift_version           = "5.1"
    
    s.source                  = { :git => "https://github.com/hiimtmac/SwiftyGraphQL.git", :tag => "#{s.version}" }
    s.source_files            = "SwiftyGraphQL/**/*.{swift}"
    s.requires_arc            = true
    
end
