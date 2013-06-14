basename = File.dirname(File.expand_path(__FILE__)).split('/')[-1]

file_cache_path           "/tmp/" + basename
data_bag_path             "/tmp/" + basename + "/data_bag"
encrypted_data_bag_secret "/tmp/" + basename  + "/data_bag_key"
cookbook_path             [ "/tmp/" + basename + "/vendor/cookbooks",
                            "/tmp/" + basename + "/cookbooks" ]
role_path                 "/tmp/" + basename + "/roles"
#log_level :debug
