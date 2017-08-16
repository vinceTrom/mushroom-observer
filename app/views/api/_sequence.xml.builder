xml.tag!(tag,
  id: object.id,
  url: object.show_url,
  type: 'sequence'
) do
    if !detail
      xml_minimal_object(xml, :observation, Observation, object.observation_id)
      xml_minimal_object(xml, :user, User, object.user_id)
    else
      xml_detailed_object(xml, :observation, object.observation)
      xml_detailed_object(xml, :user, object.user)
    end
    xml_string(xml, :locus, object.locus.truncate(object.locus_width))
    # Treat bases as html to preserve newlines and opening ">"
    xml_html_string(xml, :bases, object.bases.tp) if detail
    xml_string(xml, :archive, object.archive)
    xml_string(xml, :accession, object.accession)
    xml_html_string(xml, :notes, object.notes.tpl)
end