# Construct DiGraph
flow_graph = DiGraph(8);

# Add edges
add_edge!(flow_graph,1,2);
add_edge!(flow_graph,1,3);
add_edge!(flow_graph,1,4);
add_edge!(flow_graph,2,3);
add_edge!(flow_graph,2,5);
add_edge!(flow_graph,2,6);
add_edge!(flow_graph,3,4);
add_edge!(flow_graph,3,6);
add_edge!(flow_graph,4,7);
add_edge!(flow_graph,5,6);
add_edge!(flow_graph,5,8);
add_edge!(flow_graph,6,7);
add_edge!(flow_graph,6,8);
add_edge!(flow_graph,7,3);
add_edge!(flow_graph,7,8);

# Construct flow matrix
flow_matrix = zeros(8,8);

flow_matrix[1,2] = 10;
flow_matrix[1,3] = 5;
flow_matrix[1,4] = 15;
flow_matrix[2,3] = 4;
flow_matrix[2,5] = 9;
flow_matrix[2,6] = 15;
flow_matrix[3,4] = 4;
flow_matrix[3,6] = 8;
flow_matrix[4,7] = 16;
flow_matrix[5,6] = 15;
flow_matrix[5,8] = 10;
flow_matrix[6,7] = 15;
flow_matrix[6,8] = 10;
flow_matrix[7,3] = 6;
flow_matrix[7,8] = 10;


# Run maximum flow Test
@test maximum_flow(flow_graph,1,8,flow_matrix) == (0,zeros(8,8))
