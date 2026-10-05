"""
    calc_scale_height(temp,mean_mass,g) -> scale height

Calculate the scale height of an atmosphere.

# Arguments
- `temp`: The temperature of the atmosphere.
- `mean_mass`: The mean molecular mass of the atmosphere.
- `g`: The gravitational acceleration.

# Returns
- The scale height of the atmosphere.
"""
function calc_scale_height(temp,mean_mass,g)
    return (k_B * temp) / (mean_mass * g)
end


"""
    calc_layer_thickness(P,H) -> layer thickness

Calculate the thickness of an atmospheric layer.

# Arguments
- `P`: The pressure at the top and bottom of the layer.
- `H`: The scale height of the atmosphere.

# Returns
- The thickness of the atmospheric layer.
"""
function calc_layer_thickness(P,H)
    ln_term = log(P[1] / P[2])
    return H * ln_term
    
end
"""
    calc_num_den!(Pc,Temp,n) -> number density

Calculate the number density of an atmosphere.

# Arguments
- `Pc`: The central pressure of all layers in the atmosphere.
- `Temp`: The temperature of the atmosphere.
- `n`: The number density of the atmosphere.
"""
function calc_num_den!(Pc,Temp,n)
    @. n = (Pc * 1e5 / (k_B * Temp))
    return nothing
end



function make_atmosphere(fullatm::FullAtm)
    # Calculate the scale height of the atmosphere
    mean_mass = fullatm.parameters.mean_mass / (1e3 * avagadro_number) # Convert mean mass from g/mol to kg
    fullatm.parameters.scale_height = calc_scale_height(fullatm.parameters.temp_eq, mean_mass, fullatm.parameters.gravity) / 1e3
    
    # Calculate the thickness of each layer in the atmosphere
    layer_thickness = calc_layer_thickness(fullatm.state.P, fullatm.parameters.scale_height)
    fullatm.parameters.thickness = layer_thickness
    
    
    # Calculate the number density of each layer in the atmosphere
    calc_num_den!(fullatm.state.Pc, fullatm.parameters.temp_eq, fullatm.number_density)
    
    return nothing
    
end