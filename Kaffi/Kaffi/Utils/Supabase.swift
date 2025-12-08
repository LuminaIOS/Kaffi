//
//


import Supabase
import Foundation


let supabase_URL = "https://twsylgrqwzncrqkioodg.supabase.co"

let client = SupabaseClient(supabaseURL: URL(string : "https://twsylgrqwzncrqkioodg.supabase.co")!
                                    , supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR3c3lsZ3Jxd3puY3Jxa2lvb2RnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE1ODg2NDEsImV4cCI6MjA3NzE2NDY0MX0.TzdQQxAbe6DJr7qJFCNATDLiJRbjqMwgyH96oa8ZB9c")
let auth = client.auth




