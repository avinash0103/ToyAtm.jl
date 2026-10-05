function forward_model(planetspectrum::PlanetSpectrum, fullatm::FullAtm)

    H  = fullatm.parameters.scale_height * 1e3 # Convert scale height from km to m
    Rp = fullatm.parameters.planet_radius * R_J
    Rs = fullatm.state.star_radius * R_S 

    @. planetspectrum.depth = ((Rp + H * planetspectrum.n_scale_heights) / Rs)^2

    return nothing
end
