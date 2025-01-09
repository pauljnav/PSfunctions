function Get-InactiveTcpPort {
    Begin {
        $listener = [System.Net.Sockets.TcpListener]::new(0)
        $listener.Start()
    }
    Process {
        [int]$port = $listener.LocalEndpoint.Port
        Write-Output $port
    }
    End {
        $listener.Stop()
    }
}
