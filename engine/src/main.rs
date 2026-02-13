mod db;
mod services;

use std::net::SocketAddr;
use tonic::transport::Server;
use tracing::info;

pub mod proto {
    tonic::include_proto!("orchestra.memory.v1");
}

use services::memory::MemoryServiceImpl;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    tracing_subscriber::fmt::init();

    let addr: SocketAddr = "[::1]:50051".parse()?;
    let workspace = std::env::args()
        .skip_while(|a| a != "--workspace")
        .nth(1)
        .unwrap_or_else(|| ".".to_string());

    info!("Orchestra Engine starting on {}", addr);
    info!("Workspace: {}", workspace);

    let memory_svc = MemoryServiceImpl::new(&workspace)?;

    Server::builder()
        .add_service(proto::memory_service_server::MemoryServiceServer::new(
            memory_svc,
        ))
        .serve(addr)
        .await?;

    Ok(())
}
